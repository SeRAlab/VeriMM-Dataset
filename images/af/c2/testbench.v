`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] in;
    reg reset;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            in = 3'b000;
            @(negedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load value 3'b101", test_num);
            reset_dut();
            @(negedge clk);
            in = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load value 3'b111", test_num);
            reset_dut();
            @(negedge clk);
            in = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            in = 3'b101;
            @(posedge clk);
            @(negedge clk);
            reset = 1;
            in = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Load sequence", test_num);
            reset_dut();
            @(negedge clk);
            in = 3'b001; @(posedge clk);
            #1;
            @(negedge clk);
            in = 3'b010; @(posedge clk);
            #1;
            @(negedge clk);
            in = 3'b100; @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stability between clocks", test_num);
            reset_dut();
            @(negedge clk);
            in = 3'b011;
            @(posedge clk);
            #2;
            in = 3'b111;
            #2;
            #1;

            check_outputs(3'b011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        input [2:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
