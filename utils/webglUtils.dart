#library('WebGLUtils');
#import('dart:html');

bool DEBUG=true;
debugPrint(var p) {
  if (DEBUG) {
    print(p);
  }  
}

debugPrintMethod(f) {
  if (DEBUG) {
    f();
  }
}

WebGLProgram createProgram(WebGLRenderingContext gl, [List<WebGLShader> shaders]) {
  // Create program
  var program = gl.createProgram();
  
  // Iterate the shaders list
  if (shaders is List<WebGLShader>) {
    debugPrint("shaders.length = ${shaders.length}");
    shaders.forEach((var shader) => gl.attachShader(program, shader));
  }
  
  // Link the shader to program
  gl.linkProgram(program);
  
  // Check the linked status
  //var linked = gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS);
  //debugPrint("linked = ${linked}");
  
  return program;
}

WebGLShader loadShader(WebGLRenderingContext gl, String shaderSource, int shaderType) { 
  // Create the shader object
  var shader = gl.createShader(shaderType);
  
  // Load the shader source
  gl.shaderSource(shader, shaderSource);
  
  // Compile the shader
  gl.compileShader(shader);
  
  // Check the compile status
  // NOTE: getShaderParameter maybe borken in minfrog or frog compiler. 
  //var compiled = gl.getShaderParameter(shader, WebGLRenderingContext.COMPILE_STATUS);
  //debugPrint("compiled = ${compiled}");
  
  return shader;
}

WebGLShader createShaderFromScriptElement(WebGLRenderingContext gl, String id) {
  ScriptElement shaderScript = document.query(id);
  String shaderSource = shaderScript.text;
  int shaderType;
  if (shaderScript.type == "x-shader/x-vertex") {
    shaderType = WebGLRenderingContext.VERTEX_SHADER;
  } else if (shaderScript.type == "x-shader/x-fragment") {
    shaderType = WebGLRenderingContext.FRAGMENT_SHADER;
  } else {
    throw new Exception('*** Error: unknown shader type');
  }
  
  return loadShader(gl, shaderSource, shaderType);
}

WebGLRenderingContext getWebGLContext(CanvasElement canvas) {
  return canvas.getContext("experimental-webgl");
}


// misc functions 
void setRectangle(gl, x, y, width, height) {
  var x1 = x;
  var x2 = x + width;
  var y1 = y;
  var y2 = y + height;
  var vertices = [x1, y1,
                  x2, y1,
                  x1, y2,
                  x1, y2,
                  x2, y1,
                  x2, y2];
  gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, new Float32Array.from(vertices), WebGLRenderingContext.STATIC_DRAW);
}

int randomInt(int range) {
  return (Math.random() * range).toInt();
}