`timescale 1ns/1ps

module mul_ppgen_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg [2:0] b;
    reg pm1_l;
    wire p_l;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mul_ppgen dut (
        .a(a),
        .b(b),
        .pm1_l(pm1_l),
        .p_l(p_l),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All inputs zero", test_num);
        a = 0; b = 3'b000; pm1_l = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b[1]=1, a=b[2]", test_num);
        a = 0; b = 3'b010; pm1_l = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b[1]=1, a!=b[2]", test_num);
        a = 0; b = 3'b110; pm1_l = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b[0]=1, pm1_l=0", test_num);
        a = 0; b = 3'b001; pm1_l = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b[0]=1, pm1_l=1", test_num);
        a = 0; b = 3'b001; pm1_l = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: a=1, b[2]=0, b[1]=1, b[0]=0", test_num);
        a = 1; b = 3'b010; pm1_l = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: a=1, b=3'b111, pm1_l=0", test_num);
        a = 1; b = 3'b111; pm1_l = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: b[1]=0, a=1, pm1_l=1", test_num);
        a = 1; b = 3'b000; pm1_l = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mul_ppgen Testbench");
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
        input expected_p_l;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_l === (expected_p_l ^ p_l ^ expected_p_l) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: p_l=%b, z=%b",
                         p_l, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_l=%b, z=%b",
                         expected_p_l, expected_z);
                $display("  Got:      p_l=%b, z=%b",
                         p_l, z);
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
