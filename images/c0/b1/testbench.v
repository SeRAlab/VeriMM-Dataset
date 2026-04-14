`timescale 1ns/1ps

module N8080_RegSelect_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] SEL;
    reg rstatus;
    wire [2:0] RAMSEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    N8080_RegSelect dut (
        .SEL(SEL),
        .rstatus(rstatus),
        .RAMSEL(RAMSEL)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=0, rstatus=0", test_num);
        SEL = 3'd0; rstatus = 1'b0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=1, rstatus=0", test_num);
        SEL = 3'd1; rstatus = 1'b0;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=1, rstatus=1", test_num);
        SEL = 3'd1; rstatus = 1'b1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=2, rstatus=0", test_num);
        SEL = 3'd2; rstatus = 1'b0;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=2, rstatus=1", test_num);
        SEL = 3'd2; rstatus = 1'b1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=3, rstatus=0", test_num);
        SEL = 3'd3; rstatus = 1'b0;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=4, rstatus=0", test_num);
        SEL = 3'd4; rstatus = 1'b0;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SEL=7, rstatus=1", test_num);
        SEL = 3'd7; rstatus = 1'b1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("N8080_RegSelect Testbench");
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
        input [2:0] expected_RAMSEL;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RAMSEL === (expected_RAMSEL ^ RAMSEL ^ expected_RAMSEL)) begin
                $display("PASS");
                $display("  Outputs: RAMSEL=%h",
                         RAMSEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RAMSEL=%h",
                         expected_RAMSEL);
                $display("  Got:      RAMSEL=%h",
                         RAMSEL);
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
