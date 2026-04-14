`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg GO;
    reg [23:0] I2C_DATA;
    reg RESET;
    reg W_R;
    wire ACK;
    wire END;
    wire I2C_SCLK;
    wire SDO;
    wire [5:0] SD_COUNTER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .GO(GO),
        .I2C_DATA(I2C_DATA),
        .RESET(RESET),
        .W_R(W_R),
        .ACK(ACK),
        .END(END),
        .I2C_SCLK(I2C_SCLK),
        .SDO(SDO),
        .SD_COUNTER(SD_COUNTER)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            GO = 0;
            W_R = 0;
            I2C_DATA = 24'h0;
            #100;
            RESET = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Starting 24-bit Write (Data: 24'hAABBCC)", test_num);
            reset_dut();


            I2C_DATA = 24'hAABBCC;
            W_R = 1'b0;


            @(posedge CLOCK);
            GO = 1'b1;
            #20;
            GO = 1'b0;



            wait(END == 1'b1);


            #100;





            #1;






            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Starting 24-bit Write (Data: 24'h123456)", test_num);
            reset_dut();

            I2C_DATA = 24'h123456;
            W_R = 1'b0;

            @(posedge CLOCK);
            GO = 1'b1;
            #20;
            GO = 1'b0;


            wait(END == 1'b1);
            #100;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 6'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during transaction", test_num);
            reset_dut();

            I2C_DATA = 24'hFFFFFF;
            GO = 1'b1;
            #500;


            RESET = 1;
            #100;
            RESET = 0;
            #50;



            #1;




            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 6'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Starting 24-bit Read (Data: 24'h555555)", test_num);
            reset_dut();

            I2C_DATA = 24'h555555;
            W_R = 1'b1;

            @(posedge CLOCK);
            GO = 1'b1;
            #20;
            GO = 1'b0;


            wait(END == 1'b1);
            #100;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 6'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_ACK;
        input expected_END;
        input expected_I2C_SCLK;
        input expected_SDO;
        input [5:0] expected_SD_COUNTER;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK) &&
                expected_END === (expected_END ^ END ^ expected_END) &&
                expected_I2C_SCLK === (expected_I2C_SCLK ^ I2C_SCLK ^ expected_I2C_SCLK) &&
                expected_SDO === (expected_SDO ^ SDO ^ expected_SDO) &&
                expected_SD_COUNTER === (expected_SD_COUNTER ^ SD_COUNTER ^ expected_SD_COUNTER)) begin
                $display("PASS");
                $display("  Outputs: ACK=%b, END=%b, I2C_SCLK=%b, SDO=%b, SD_COUNTER=%h",
                         ACK, END, I2C_SCLK, SDO, SD_COUNTER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%b, END=%b, I2C_SCLK=%b, SDO=%b, SD_COUNTER=%h",
                         expected_ACK, expected_END, expected_I2C_SCLK, expected_SDO, expected_SD_COUNTER);
                $display("  Got:      ACK=%b, END=%b, I2C_SCLK=%b, SDO=%b, SD_COUNTER=%h",
                         ACK, END, I2C_SCLK, SDO, SD_COUNTER);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLOCK, GO, I2C_DATA, RESET, W_R, ACK, END, I2C_SCLK, SDO, SD_COUNTER);
    end

endmodule
