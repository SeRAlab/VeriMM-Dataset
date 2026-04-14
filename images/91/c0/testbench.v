`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg dir;
    reg [4:0] shift_amt;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .dir(dir),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Shift Left by 0");
            data = 32'h12345678;
            shift_amt = 5'd0;
            dir = 1'b1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift Right by 0");
            data = 32'h12345678;
            shift_amt = 5'd0;
            dir = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left by 1");
            data = 32'h00000001;
            shift_amt = 5'd1;
            dir = 1'b1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right by 1");
            data = 32'h80000000;
            shift_amt = 5'd1;
            dir = 1'b0;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Left by 16");
            data = 32'h0000FFFF;
            shift_amt = 5'd16;
            dir = 1'b1;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Right by 16");
            data = 32'hFFFF0000;
            shift_amt = 5'd16;
            dir = 1'b0;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift Left by 31");
            data = 32'h00000001;
            shift_amt = 5'd31;
            dir = 1'b1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Shift Right by 31");
            data = 32'h80000000;
            shift_amt = 5'd31;
            dir = 1'b0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Shift Left (All bits set) by 8");
            data = 32'hFFFFFFFF;
            shift_amt = 5'd8;
            dir = 1'b1;
            #1;

            check_outputs(32'hFFFFFF00);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Shift Right (All bits set) by 8");
            data = 32'hFFFFFFFF;
            shift_amt = 5'd8;
            dir = 1'b0;
            #1;

            check_outputs(32'h00FFFFFF);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Alternating pattern Shift Left by 4");
            data = 32'hAAAAAAAA;
            shift_amt = 5'd4;
            dir = 1'b1;
            #1;

            check_outputs(32'hAAAAAAA0);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Alternating pattern Shift Right by 4");
            data = 32'h55555555;
            shift_amt = 5'd4;
            dir = 1'b0;
            #1;

            check_outputs(32'h05555555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
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
        testcase011();
        testcase012();
        
        
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
            #1; // Small delay for combinational logic to settle
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

endmodule
