`timescale 1ns/1ps

module conv_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Single bit 1", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 1;
            #2 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sequence 1, 0", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 0;
            #2 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sequence 1, 1", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 1;
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sequence 1, 1, 1", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 1;
            #2 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Sequence 1, 0, 1, 1", test_num);
            reset_dut();
            @(negedge clk); data_in = 1;
            @(negedge clk); data_in = 0;
            @(negedge clk); data_in = 1;
            @(negedge clk); data_in = 1;
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Sequence 0, 0, 0", test_num);
            reset_dut();
            @(negedge clk); data_in = 0;
            @(negedge clk); data_in = 0;
            @(negedge clk); data_in = 0;
            #2 #1;
 check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
