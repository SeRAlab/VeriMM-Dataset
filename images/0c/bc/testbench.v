`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in_data;
    reg reset;
    wire [4:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_data = 5'b0;
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
            $display("\nTestcase %0d: Input = 0", test_num);
            reset_dut();
            in_data = 5'd0;
            @(posedge clk);
            in_data = 5'd0;
            repeat(6) @(posedge clk);
            #2;

            #1;


            check_outputs(5'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Input = 10", test_num);
            reset_dut();
            in_data = 5'd10;
            @(posedge clk);
            in_data = 5'd0;
            repeat(6) @(posedge clk);
            #2;

            #1;


            check_outputs(5'd13);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Input = 31 (Overflow check)", test_num);
            reset_dut();
            in_data = 5'd31;
            @(posedge clk);
            in_data = 5'd0;
            repeat(6) @(posedge clk);
            #2;

            #1;


            check_outputs(5'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Input = 20 (Multiplication truncation)", test_num);
            reset_dut();
            in_data = 5'd20;
            @(posedge clk);
            in_data = 5'd0;
            repeat(6) @(posedge clk);
            #2;



            #1;




            check_outputs(5'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Input = 5", test_num);
            reset_dut();
            in_data = 5'd5;
            @(posedge clk);
            in_data = 5'd0;
            repeat(6) @(posedge clk);
            #2;

            #1;


            check_outputs(5'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [4:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, reset, out_data);
    end

endmodule
