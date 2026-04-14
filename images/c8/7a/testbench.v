`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA_IN;
    reg [3:0] MASK;
    wire [3:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .DATA_IN(DATA_IN),
        .MASK(MASK),
        .DATA_OUT(DATA_OUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones logic (1111 & 1111)", test_num);
        DATA_IN = 4'b1111;
        MASK    = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros logic (0000 & 0000)", test_num);
        DATA_IN = 4'b0000;
        MASK    = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero mask (1010 & 0000)", test_num);
        DATA_IN = 4'b1010;
        MASK    = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity mask (1010 & 1111)", test_num);
        DATA_IN = 4'b1010;
        MASK    = 4'b1111;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (1010 & 0101)", test_num);
        DATA_IN = 4'b1010;
        MASK    = 4'b0101;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit selection LSB (1111 & 0001)", test_num);
        DATA_IN = 4'b1111;
        MASK    = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit selection MSB (1111 & 1000)", test_num);
        DATA_IN = 4'b1111;
        MASK    = 4'b1000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Partial overlap (1100 & 1010)", test_num);
        DATA_IN = 4'b1100;
        MASK    = 4'b1010;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit high (0100 & 0100)", test_num);
        DATA_IN = 4'b0100;
        MASK    = 4'b0100;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random pattern (0111 & 0011)", test_num);
        DATA_IN = 4'b0111;
        MASK    = 4'b0011;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
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
        input [3:0] expected_DATA_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
