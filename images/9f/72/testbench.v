`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] notRomMIptr;
    wire EntryPoint;
    wire s_mov;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .notRomMIptr(notRomMIptr),
        .EntryPoint(EntryPoint),
        .s_mov(s_mov)
    );
    task update_expected;

        input [7:0] addr;
        begin
            inv_ptr = ~addr;
            exp_ep = (addr == 8'h00);



            n1 = ~(inv_ptr[0] | inv_ptr[1]);
            n2 = ~(inv_ptr[2] & inv_ptr[3]);
            n3 = (inv_ptr[4] & inv_ptr[5]);
            n4 = (inv_ptr[6] ^ inv_ptr[7]);


            exp_sm = n1 ^ n2 ^ n3 ^ n4;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        notRomMIptr = 8'h00;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        notRomMIptr = 8'hFF;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        notRomMIptr = 8'hAA;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        notRomMIptr = 8'h55;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        notRomMIptr = 8'h01;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        notRomMIptr = 8'h80;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        notRomMIptr = 8'h0F;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        notRomMIptr = 8'hF0;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        notRomMIptr = 8'h33;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        notRomMIptr = 8'hCC;
        update_expected(notRomMIptr);
        #1;

        check_outputs(exp_ep, exp_sm);
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
        input expected_EntryPoint;
        input expected_s_mov;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EntryPoint === (expected_EntryPoint ^ EntryPoint ^ expected_EntryPoint) &&
                expected_s_mov === (expected_s_mov ^ s_mov ^ expected_s_mov)) begin
                $display("PASS");
                $display("  Outputs: EntryPoint=%b, s_mov=%b",
                         EntryPoint, s_mov);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EntryPoint=%b, s_mov=%b",
                         expected_EntryPoint, expected_s_mov);
                $display("  Got:      EntryPoint=%b, s_mov=%b",
                         EntryPoint, s_mov);
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
