`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] message;
    reg rst;
    wire done;
    wire [63:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .enable(enable),
        .message(message),
        .rst(rst),
        .done(done),
        .encoded(encoded)
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
            message = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Message", test_num);
            reset_dut();
            message = 32'h00000000;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Bytes (01 02 03 04)", test_num);
            reset_dut();
            message = 32'h01020304;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done);
            @(posedge clk);



            #1;




            check_outputs({32'h01020304, 32'h8F7B2A10});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (FF FF FF FF)", test_num);
            reset_dut();
            message = 32'hFFFFFFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs({32'hFFFFFFFF, 32'h71A2C3B4});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Pattern (A5 A5 A5 A5)", test_num);
            reset_dut();
            message = 32'hA5A5A5A5;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs({32'hA5A5A5A5, 32'hD4E5F607});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ReedSolomonEncoder Testbench");
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
        input expected_done;
        input [63:0] expected_encoded;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: done=%b, encoded=%h",
                         done, encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, encoded=%h",
                         expected_done, expected_encoded);
                $display("  Got:      done=%b, encoded=%h",
                         done, encoded);
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
        $dumpvars(0,clk, enable, message, rst, done, encoded);
    end

endmodule
