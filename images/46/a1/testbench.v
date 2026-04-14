`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [15:0] data_in;
    reg reset;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Load Immediate", test_num);
            reset_dut();
            data_in = 16'h0155;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0055);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Addition Operation", test_num);
            reset_dut();
            data_in = 16'h0110;
            @(posedge clk);
            #1;
            data_in = 16'h0220;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0030);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Subtraction Operation", test_num);
            reset_dut();
            data_in = 16'h0150;
            @(posedge clk);
            #1;
            data_in = 16'h0310;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Logical AND", test_num);
            reset_dut();
            data_in = 16'h01FF;
            @(posedge clk);
            #1;
            data_in = 16'h04AA;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Logical OR", test_num);
            reset_dut();
            data_in = 16'h0155;
            @(posedge clk);
            #1;
            data_in = 16'h05AA;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Logical XOR", test_num);
            reset_dut();
            data_in = 16'h01F0;
            @(posedge clk);
            #1;
            data_in = 16'h060F;
            @(posedge clk);
            #1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Sequence (Load -> Add -> Sub -> XOR)", test_num);
            reset_dut();
            data_in = 16'h0105;
            @(posedge clk); #1;
            data_in = 16'h020A;
            @(posedge clk); #1;
            data_in = 16'h0303;
            @(posedge clk); #1;
            data_in = 16'h060C;
            @(posedge clk); #1;
            data_in = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Arithmetic Wrap (Underflow)", test_num);
            reset_dut();
            data_in = 16'h0100;
            @(posedge clk); #1;
            data_in = 16'h0301;
            @(posedge clk); #1;
            data_in = 16'h0000;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h00FF);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, reset, data_out);
    end

endmodule
