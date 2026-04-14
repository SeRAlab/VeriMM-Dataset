`timescale 1ns/1ps

module mux_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_8bit dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: Select in0");
        test_num = test_num + 1;
        in0 = 8'hAA;
        in1 = 8'h55;
        sel = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Select in1");
        test_num = test_num + 1;
        in0 = 8'hAA;
        in1 = 8'h55;
        sel = 1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Boundary all zeros on in0");
        test_num = test_num + 1;
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Boundary all ones on in1");
        test_num = test_num + 1;
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Alternating bits on in0");
        test_num = test_num + 1;
        in0 = 8'hF0;
        in1 = 8'h0F;
        sel = 0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Alternating bits on in1");
        test_num = test_num + 1;
        in0 = 8'hF0;
        in1 = 8'h0F;
        sel = 1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Verify in1 change does not affect out when sel=0");
        test_num = test_num + 1;
        in0 = 8'h12;
        in1 = 8'h34;
        sel = 0;
        #5;
        in1 = 8'h56;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Verify in0 change does not affect out when sel=1");
        test_num = test_num + 1;
        in0 = 8'h78;
        in1 = 8'h9A;
        sel = 1;
        #5;
        in0 = 8'hBC;
        #1;

        check_outputs(8'h9A);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Data transparency 8'h69 on in0");
        test_num = test_num + 1;
        in0 = 8'h69;
        in1 = 8'h96;
        sel = 0;
        #1;

        check_outputs(8'h69);
    end
        endtask

    task testcase10;

    begin
        $display("Testcase 010: Data transparency 8'h96 on in1");
        test_num = test_num + 1;
        in0 = 8'h69;
        in1 = 8'h96;
        sel = 1;
        #1;

        check_outputs(8'h96);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_8bit Testbench");
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
        testcase10();
        
        
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
        input [7:0] expected_out;
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
