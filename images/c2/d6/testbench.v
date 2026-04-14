`timescale 1ns/1ps

module karnaugh_map_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    karnaugh_map dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .F(F)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0, C=0, D=0", test_num);
        A = 0; B = 0; C = 0; D = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0, C=0, D=1", test_num);
        A = 0; B = 0; C = 0; D = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0, C=1, D=0", test_num);
        A = 0; B = 0; C = 1; D = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0, C=1, D=1", test_num);
        A = 0; B = 0; C = 1; D = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=1, C=0, D=0", test_num);
        A = 0; B = 1; C = 0; D = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=1, C=0, D=1", test_num);
        A = 0; B = 1; C = 0; D = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=1, C=1, D=0", test_num);
        A = 0; B = 1; C = 1; D = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=1, C=1, D=1", test_num);
        A = 0; B = 1; C = 1; D = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=0, C=0, D=0", test_num);
        A = 1; B = 0; C = 0; D = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=0, C=0, D=1", test_num);
        A = 1; B = 0; C = 0; D = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=0, C=1, D=0", test_num);
        A = 1; B = 0; C = 1; D = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=0, C=1, D=1", test_num);
        A = 1; B = 0; C = 1; D = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=1, C=0, D=0", test_num);
        A = 1; B = 1; C = 0; D = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=1, C=0, D=1", test_num);
        A = 1; B = 1; C = 0; D = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=1, C=1, D=0", test_num);
        A = 1; B = 1; C = 1; D = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=1, C=1, D=1", test_num);
        A = 1; B = 1; C = 1; D = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("karnaugh_map Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%b",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b",
                         expected_F);
                $display("  Got:      F=%b",
                         F);
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
