`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg rst;
    wire [6:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rst(rst),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 4'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'h0 (All Zeros)", test_num);
            reset_dut();
            data_in = 4'h0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'h1", test_num);
            reset_dut();
            data_in = 4'h1;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h0B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'hA (1010)", test_num);
            reset_dut();
            data_in = 4'hA;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h53);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'hF (All Ones)", test_num);
            reset_dut();
            data_in = 4'hF;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'h5 (0101)", test_num);
            reset_dut();
            data_in = 4'h5;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h2C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 4'h8 (1000)", test_num);
            reset_dut();
            data_in = 4'h8;
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(7'h45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input [6:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, data_in, enable, rst, encoded_out);
    end

endmodule
