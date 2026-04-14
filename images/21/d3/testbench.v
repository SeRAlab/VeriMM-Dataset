`timescale 1ns/1ps

module decoder5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder5to32 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Values (0 and 31)", test_num);


        A = 5'd0;
        #1;

        check_outputs(32'h00000001);


        A = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power-of-two inputs (One-hot selection)", test_num);

        A = 5'd1;
        #1;

        check_outputs(32'h00000002);

        A = 5'd2;
        #1;

        check_outputs(32'h00000004);

        A = 5'd4;
        #1;

        check_outputs(32'h00000010);

        A = 5'd8;
        #1;

        check_outputs(32'h00000100);

        A = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary patterns", test_num);

        A = 5'd7;
        #1;

        check_outputs(32'h00000080);

        A = 5'd15;
        #1;

        check_outputs(32'h00008000);

        A = 5'd23;
        #1;

        check_outputs(32'h00800000);

        A = 5'd30;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Exhaustive walk-through (0 to 31)", test_num);
        for (i = 0; i < 32; i = i + 1) begin
            A = i;
            #1;

            check_outputs(32'h1 << i);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder5to32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
