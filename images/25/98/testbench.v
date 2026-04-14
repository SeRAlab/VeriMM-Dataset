`timescale 1ns/1ps

module dac_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    reg valid;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_8bit dut (
        .din(din),
        .valid(valid),
        .dout(dout)
    );
    task testcase001;

    begin
        $display("Running testcase001: Input 8'h00, Valid=1");
        test_num = test_num + 1;
        din = 8'h00;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Input 8'hFF, Valid=1");
        test_num = test_num + 1;
        din = 8'hFF;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Input 8'h80, Valid=1");
        test_num = test_num + 1;
        din = 8'h80;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Input 8'hAA, Valid=1");
        test_num = test_num + 1;
        din = 8'hAA;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Input 8'h55, Valid=1");
        test_num = test_num + 1;
        din = 8'h55;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Input 8'h01, Valid=1");
        test_num = test_num + 1;
        din = 8'h01;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Input 8'hFE, Valid=1");
        test_num = test_num + 1;
        din = 8'hFE;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Input 8'h3C, Valid=1");
        test_num = test_num + 1;
        din = 8'h3C;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
