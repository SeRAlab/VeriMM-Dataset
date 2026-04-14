`timescale 1ns/1ps

module decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_2to4 dut (
        .en(en),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: en=0, sel=00 (Disabled)");
        en = 1'b0;
        sel = 2'b00;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: en=0, sel=11 (Disabled check)");
        en = 1'b0;
        sel = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: en=1, sel=00 (Out bit 0)");
        en = 1'b1;
        sel = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: en=1, sel=01 (Out bit 1)");
        en = 1'b1;
        sel = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: en=1, sel=10 (Out bit 2)");
        en = 1'b1;
        sel = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: en=1, sel=11 (Out bit 3)");
        en = 1'b1;
        sel = 2'b11;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_2to4 Testbench");
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
        input [3:0] expected_out;
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
