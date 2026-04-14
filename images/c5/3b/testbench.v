`timescale 1ns/1ps

module sky130_fd_sc_hd__fill_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_hd__fill dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR)
    );
    task testcase001;

        begin


            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            #10;

            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            $display("Running Testcase001: VPB > VNB");
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin


            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            #10;

            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b0; VNB = 1'b1;
            $display("Running Testcase002: VPB < VNB");
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin


            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            #10;

            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b1;
            $display("Running Testcase003: VPB == VNB (High)");
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin


            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            #10;

            VPWR = 1'b1; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            $display("Running Testcase004: VPB == VNB (Low)");
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin


            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b0; VNB = 1'b0;
            #10;

            VPWR = 1'b0; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
            $display("Running Testcase005: Power Off Test");
            #1;

            check_outputs();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sky130_fd_sc_hd__fill Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
