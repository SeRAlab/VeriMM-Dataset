`timescale 1ns/1ps

module fm_3d_norm_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] i_e;
    reg [16:0] i_f;
    reg i_s;
    wire [21:0] o_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_3d_norm dut (
        .i_e(i_e),
        .i_f(i_f),
        .i_s(i_s),
        .o_b(o_b)
    );
    task testcase001;

    begin
        test_num = 1;
        i_s = 0;
        i_e = 5'd10;
        i_f = 17'h08000;
        $display("Test %0d: Positive, Already Normalized", test_num);
        #1;

        check_outputs(22'h0A8000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i_s = 1;
        i_e = 5'd10;
        i_f = 17'h10001;
        $display("Test %0d: Negative, Carry Detection (Shift Right)", test_num);

        #1;


        check_outputs(22'h2B8000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i_s = 0;
        i_e = 5'd10;
        i_f = 17'h04000;
        $display("Test %0d: Shift Left by 1", test_num);

        #1;


        check_outputs(22'h098000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i_s = 0;
        i_e = 5'd15;
        i_f = 17'h00800;
        $display("Test %0d: Shift Left by 4", test_num);

        #1;


        check_outputs(22'h0B8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i_s = 0;
        i_e = 5'd10;
        i_f = 17'h00000;
        $display("Test %0d: Zero Fraction Input", test_num);

        #1;


        check_outputs(22'h000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i_s = 0;
        i_e = 5'h1F;
        i_f = 17'h10000;
        $display("Test %0d: Exponent Saturation at Max", test_num);

        #1;


        check_outputs(22'h1F8000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i_s = 1;
        i_e = 5'd20;
        i_f = 17'h00001;
        $display("Test %0d: Maximum Shift Left (15 bits)", test_num);

        #1;


        check_outputs(22'h258000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i_s = 1;
        i_e = 5'd12;
        i_f = 17'h02000;
        $display("Test %0d: Negative, Shift Left by 2", test_num);

        #1;


        check_outputs(22'h2A8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_3d_norm Testbench");
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
        input [21:0] expected_o_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_b === (expected_o_b ^ o_b ^ expected_o_b)) begin
                $display("PASS");
                $display("  Outputs: o_b=%h",
                         o_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_b=%h",
                         expected_o_b);
                $display("  Got:      o_b=%h",
                         o_b);
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
