`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] addr;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .dout(dout)
    );
    task testcase001;

    begin

        addr = 6'b000000;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase002;

    begin

        addr = 6'b000001;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin

        addr = 6'b100000;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase004;

    begin

        addr = 6'b100001;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin

        addr = 6'b000010;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase006;

    begin

        addr = 6'b011110;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase007;

    begin

        addr = 6'b111111;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase008;

    begin

        addr = 6'b001011;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase009;

    begin

        addr = 6'b110000;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin

        addr = 6'b110101;
        #1;

        check_outputs(4'h3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_dout;
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
