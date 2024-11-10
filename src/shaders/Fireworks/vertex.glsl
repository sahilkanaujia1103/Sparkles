uniform float uSize;
uniform vec2 uResolution;
attribute float aSize;
attribute float aTimeMultuplier;
uniform float uProgress;
float remap(float value, float inMin, float inMax, float outMin, float outMax) {
    return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin);
}

void main(){
    vec3 newPosition=position;
    float progress=uProgress*aTimeMultuplier;
    //exploding
    float exploding=remap(progress,0.0,0.3,0.0,1.0);
    exploding=clamp(exploding,0.0,1.0);
    exploding=1.0-pow(1.0-exploding,3.0);
    newPosition*=exploding;
    //falling
     float falling=remap(progress,0.1,1.0,0.0,1.0);
    falling=clamp(falling,0.0,1.0);
    falling=1.0-pow(1.0-falling,3.0);
    newPosition.y-=falling*0.2;
    //scaling
    float sizeOpeningProgress=remap(progress,0.0,0.125,0.0,1.0);
    float sizeClosingProgress=remap(progress,0.125,1.0,1.0,0.0);
    float scaling=min(sizeOpeningProgress,sizeClosingProgress);
    scaling=clamp(scaling,0.0,1.0);
    //twinkling
    float twinkling=remap(progress,0.2,0.8,0.0,1.0);
    twinkling=clamp(twinkling,0.0,1.0);
    float sizeTwinking=sin(progress*30.0)*0.5 + 0.5;
    sizeTwinking=1.0-sizeTwinking*twinkling;


    vec4 modelPosition=modelMatrix*vec4(newPosition,1.0);
    vec4 viewPosition=viewMatrix*modelPosition;
    gl_Position=projectionMatrix*viewPosition;
    gl_PointSize=uSize*uResolution.y*aSize*scaling*sizeTwinking;
    gl_PointSize*=1.0/(-viewPosition.z);
    if(gl_PointSize<1.0){
         gl_Position=vec4(9999.9);
    }
}