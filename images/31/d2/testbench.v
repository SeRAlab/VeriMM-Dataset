`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg dir;
    reg [1:0] shamt;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .dir(dir),
        .shamt(shamt),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Left shift by 0 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b0;
        shamt = 2'b00;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Left shift by 1 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b0;
        shamt = 2'b01;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Left shift by 2 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b0;
        shamt = 2'b10;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Left shift by 3 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b0;
        shamt = 2'b11;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Right shift by 0 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b1;
        shamt = 2'b00;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Right shift by 1 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b1;
        shamt = 2'b01;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Right shift by 2 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b1;
        shamt = 2'b10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Right shift by 3 (Data=4'b1011)", test_num);
        data = 4'b1011;
        dir = 1'b1;
        shamt = 2'b11;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Left shift by 2 (Data=4'b1111)", test_num);
        data = 4'b1111;
        dir = 1'b0;
        shamt = 2'b10;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Right shift by 1 (Data=4'b0000)", test_num);
        data = 4'b0000;
        dir = 1'b1;
        shamt = 2'b01;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
