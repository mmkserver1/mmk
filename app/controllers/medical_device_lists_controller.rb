class MedicalDeviceListsController < ApplicationController

  before_filter :find_medical_device_list, only: [:show, :update, :destroy]

  def index
    @medical_device_lists = MedicalDeviceList.all
    render xml: @medical_device_lists
  end

  def create
    if (attrs = params[:medical_device_list]).present?
      @medical_device_list = MedicalDeviceList.find_or_initialize_by_address(attrs[:address])
      @medical_device_list.device_type = attrs[:device_type]
      if @medical_device_list.save
        render xml: @medical_device_list
      else
        render xml: @medical_device_list.errors, status: :unprocessable_entity
      end
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def show
    render xml: @medical_device_list
  end

  def update
    if @medical_device_list.update_attributes(params[:medical_device_list])
      render xml: @medical_device_list
    else
      render nothing: true, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @medical_device_list.destroy
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def find_medical_device_list
    @medical_device_list = MedicalDeviceList.find(params[:id])
  end
end
