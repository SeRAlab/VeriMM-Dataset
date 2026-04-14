`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg [3:0] GP;
    reg [3:0] PP;
    wire C12;
    wire C4;
    wire C8;
    wire GPP;
    wire PPP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .GP(GP),
        .PP(PP),
        .C12(C12),
        .C4(C4),
        .C8(C8),
        .GPP(GPP),
        .PPP(PPP)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros", test_num);
            CI = 0; GP = 4'b0000; PP = 4'b0000;
            #1;

            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Carry-in propagation to C4", test_num);
            CI = 1; GP = 4'b0000; PP = 4'b0001;
            #1;

            check_outputs(0, 1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Carry-in propagation to C8", test_num);
            CI = 1; GP = 4'b0000; PP = 4'b0011;
            #1;

            check_outputs(0, 1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Carry-in propagation to C12", test_num);
            CI = 1; GP = 4'b0000; PP = 4'b0111;
            #1;

            check_outputs(1, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Group Propagate (PPP) check", test_num);
            CI = 0; GP = 4'b0000; PP = 4'b1111;
            #1;

            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Generate G0 impacts C4, C8, C12", test_num);
            CI = 0; GP = 4'b0001; PP = 4'b0110;




            #1;





            check_outputs(1, 1, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Group Generate (GPP) from G0", test_num);
            CI = 0; GP = 4'b0001; PP = 4'b1110;

            #1;


            check_outputs(1, 1, 1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Generate G3 only affects GPP", test_num);
            CI = 0; GP = 4'b1000; PP = 4'b0000;
            #1;

            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Carry-in blocked by P=0", test_num);
            CI = 1; GP = 4'b0000; PP = 4'b1110;
            #1;

            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Full bits set", test_num);
            CI = 1; GP = 4'b1111; PP = 4'b1111;
            #1;

            check_outputs(1, 1, 1, 1, 1);
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
        input expected_C12;
        input expected_C4;
        input expected_C8;
        input expected_GPP;
        input expected_PPP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C12 === (expected_C12 ^ C12 ^ expected_C12) &&
                expected_C4 === (expected_C4 ^ C4 ^ expected_C4) &&
                expected_C8 === (expected_C8 ^ C8 ^ expected_C8) &&
                expected_GPP === (expected_GPP ^ GPP ^ expected_GPP) &&
                expected_PPP === (expected_PPP ^ PPP ^ expected_PPP)) begin
                $display("PASS");
                $display("  Outputs: C12=%b, C4=%b, C8=%b, GPP=%b, PPP=%b",
                         C12, C4, C8, GPP, PPP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C12=%b, C4=%b, C8=%b, GPP=%b, PPP=%b",
                         expected_C12, expected_C4, expected_C8, expected_GPP, expected_PPP);
                $display("  Got:      C12=%b, C4=%b, C8=%b, GPP=%b, PPP=%b",
                         C12, C4, C8, GPP, PPP);
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
