`timescale 1ns/1ps

module constant_output_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] din;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    constant_output dut (
        .control(control),
        .din(din),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Control=0, Din=0", test_num);
            din = 32'h0000_0000;
            control = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Control=1, Din=0", test_num);
            din = 32'h0000_0000;
            control = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Control=0, Din=All Fs", test_num);
            din = 32'hFFFF_FFFF;
            control = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Control=1, Din=All Fs", test_num);
            din = 32'hFFFF_FFFF;
            control = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Control=0, Din=Walking Bits", test_num);
            din = 32'hAAAA_5555;
            control = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Control=1, Din=Walking Bits", test_num);
            din = 32'h5555_AAAA;
            control = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Control=0, Din=Random Value", test_num);
            din = 32'h1234_5678;
            control = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Control=1, Din=Random Value", test_num);
            din = 32'h8765_4321;
            control = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("constant_output Testbench");
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
        input [31:0] expected_dout;
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
