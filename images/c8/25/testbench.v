`timescale 1ns/1ps

module REG32_tb;

    // Testbench signals (sequential circuit)
    reg R;
    reg clk;
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    REG32 dut (
        .R(R),
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            R = 1;
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            R = 0;
            in = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Data Load", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'h12345678;
            R = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: All Bits Set", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multi-cycle Update", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'hAAAAAAAA;
            @(posedge clk);
            @(negedge clk);
            in = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Data Hold on Falling Edge", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'hBCBCBCBC;
            @(posedge clk);
            @(negedge clk);
            in = 32'h0;
            #1;
            #1;

            check_outputs(32'hBCBCBCBC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Reset Toggle and Load", test_num);
            reset_dut();
            @(negedge clk);
            in = 32'h11223344;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("REG32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_out;
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
        $dumpvars(0,R, clk, in, out);
    end

endmodule
