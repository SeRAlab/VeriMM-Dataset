`timescale 1ns/1ps

module decoder4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [15:0] onehot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder4to16 dut (
        .bin(bin),
        .onehot(onehot)
    );
    task testcase001;

        begin
            $display("Test 001: Input bin = 4'd0");
            bin = 4'd0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Input bin = 4'd1");
            bin = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Input bin = 4'd2");
            bin = 4'd2;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Input bin = 4'd4");
            bin = 4'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Input bin = 4'd7");
            bin = 4'd7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Input bin = 4'd8");
            bin = 4'd8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Input bin = 4'd10 (A)");
            bin = 4'hA;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Input bin = 4'd13 (D)");
            bin = 4'hD;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: Input bin = 4'd15 (F)");
            bin = 4'hF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        integer i;
        begin
            $display("Test 010: Exhaustive Sweep (0-15)");
            for (i = 0; i < 16; i = i + 1) begin
                bin = i;
                #1;

                check_outputs(16'h1 << i);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder4to16 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_onehot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_onehot === (expected_onehot ^ onehot ^ expected_onehot)) begin
                $display("PASS");
                $display("  Outputs: onehot=%h",
                         onehot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: onehot=%h",
                         expected_onehot);
                $display("  Got:      onehot=%h",
                         onehot);
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

endmodule
