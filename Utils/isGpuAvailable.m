function canUseGPU = isGpuAvailable()
    try
        gpuArray(1);
        canUseGPU=true;
    catch
        canUseGPU=false;
    end
end