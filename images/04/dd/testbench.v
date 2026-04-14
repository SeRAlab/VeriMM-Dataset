`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg enable;
    reg load;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            enable = 0;
            data_in = 5'b00000;


            @(posedge clk);
            #1;

            load = 1;
            enable = 1;
            data_in = 5'b00000;
            @(posedge clk);
            #1;
            load = 0;
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Parallel Load with Enable High", test_num);

            data_in = 5'b10101;
            load = 1;
            enable = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load with Enable Low", test_num);

            data_in = 5'b11111;
            load = 1;
            enable = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Output after Loading", test_num);


            data_in = 5'b01010;
            load = 1;
            enable = 0;
            @(posedge clk);
            #1;


            load = 0;
            enable = 1;



            #1;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Mode (Load=0, Enable=0)", test_num);


            data_in = 5'b10010;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;


            load = 0;
            enable = 0;
            data_in = 5'b00000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b10010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite check with Enable Low", test_num);


            data_in = 5'b00111;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;


            data_in = 5'b11000;
            load = 0;
            enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b00111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, load, data_out);
    end

endmodule
