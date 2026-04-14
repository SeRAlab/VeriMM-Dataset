`timescale 1ns/1ps

module bilinear_interp_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Q11;
    reg [7:0] Q12;
    reg [7:0] Q21;
    reg [7:0] Q22;
    reg [7:0] dx;
    reg [7:0] dy;
    wire [7:0] Q_interpolated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interp dut (
        .Q11(Q11),
        .Q12(Q12),
        .Q21(Q21),
        .Q22(Q22),
        .dx(dx),
        .dy(dy),
        .Q_interpolated(Q_interpolated)
    );
    task testcase001;

    begin
        $display("Testcase 001: All zeros");
        test_num = test_num + 1;
        Q11 = 8'd0; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd0;
        dx = 8'd0; dy = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Origin (dx=0, dy=0) - Should equal Q11");
        test_num = test_num + 1;
        Q11 = 8'd100; Q12 = 8'd200; Q21 = 8'd50; Q22 = 8'd25;
        dx = 8'd0; dy = 8'd0;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Uniform pixels - Result should match input");
        test_num = test_num + 1;
        Q11 = 8'd150; Q12 = 8'd150; Q21 = 8'd150; Q22 = 8'd150;
        dx = 8'd128; dy = 8'd64;
        #1;

        check_outputs(8'd150);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Horizontal midpoint (dx=128, dy=0)");
        test_num = test_num + 1;
        Q11 = 8'd100; Q12 = 8'd200; Q21 = 8'd0; Q22 = 8'd0;
        dx = 8'd128; dy = 8'd0;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Vertical midpoint (dx=0, dy=128)");
        test_num = test_num + 1;
        Q11 = 8'd50; Q12 = 8'd0; Q21 = 8'd150; Q22 = 8'd0;
        dx = 8'd0; dy = 8'd128;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Geometric Center (dx=128, dy=128)");
        test_num = test_num + 1;
        Q11 = 8'd0; Q12 = 8'd255; Q21 = 8'd255; Q22 = 8'd0;
        dx = 8'd128; dy = 8'd128;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Near right edge (dx=255, dy=0)");
        test_num = test_num + 1;
        Q11 = 8'd100; Q12 = 8'd200; Q21 = 8'd100; Q22 = 8'd200;
        dx = 8'd255; dy = 8'd0;

        #1;


        check_outputs(8'd199);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Near bottom edge (dx=0, dy=255)");
        test_num = test_num + 1;
        Q11 = 8'd10; Q12 = 8'd10; Q21 = 8'd210; Q22 = 8'd210;
        dx = 8'd0; dy = 8'd255;

        #1;


        check_outputs(8'd209);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: High fractional values (dx=255, dy=255)");
        test_num = test_num + 1;
        Q11 = 8'd0; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd255;
        dx = 8'd255; dy = 8'd255;


        #1;



        check_outputs(8'd252);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interp Testbench");
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
        input [7:0] expected_Q_interpolated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q_interpolated === (expected_Q_interpolated ^ Q_interpolated ^ expected_Q_interpolated)) begin
                $display("PASS");
                $display("  Outputs: Q_interpolated=%h",
                         Q_interpolated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_interpolated=%h",
                         expected_Q_interpolated);
                $display("  Got:      Q_interpolated=%h",
                         Q_interpolated);
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
