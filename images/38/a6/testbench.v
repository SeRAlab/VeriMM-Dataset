`timescale 1ns/1ps

module mux32to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [4:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32to1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select bit 0 (Logic High)");
            in = 32'h0000_0001;
            sel = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select bit 0 (Logic Low)");
            in = 32'hFFFF_FFFE;
            sel = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select bit 31 (Logic High)");
            in = 32'h8000_0000;
            sel = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select bit 31 (Logic Low)");
            in = 32'h7FFF_FFFF;
            sel = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select bit 15 (Midpoint High)");
            in = 32'h0000_8000;
            sel = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select bit 16 (Midpoint Low)");
            in = 32'hFFFE_FFFF;
            sel = 5'd16;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating Pattern (Select bit 1)");
            in = 32'hAAAA_AAAA;
            sel = 5'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating Pattern (Select bit 0)");
            in = 32'hAAAA_AAAA;
            sel = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        integer i;
        begin
            $display("Testcase 009: Walking 1 Sweep");
            for (i = 0; i < 32; i = i + 1) begin
                in = (1 << i);
                sel = i[4:0];
                #1;

                check_outputs(1'b1);
            end
        end
        endtask

    task testcase010;

        integer i;
        begin
            $display("Testcase 010: All Ones with Single 0 Sweep");
            for (i = 0; i < 32; i = i + 1) begin
                in = ~(1 << i);
                sel = i[4:0];
                #1;

                check_outputs(1'b0);
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
        $display("mux32to1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

endmodule
