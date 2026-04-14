`timescale 1ns/1ps

module eeprom_control_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] DATA_IN;
    reg READ_EN;
    reg WRITE_EN;
    wire [4:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_control dut (
        .DATA_IN(DATA_IN),
        .READ_EN(READ_EN),
        .WRITE_EN(WRITE_EN),
        .DATA_OUT(DATA_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Write 5'h0A", test_num);
            DATA_IN = 5'h0A;
            WRITE_EN = 1;
            READ_EN = 0;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Hold previous state (5'h0A)", test_num);
            DATA_IN = 5'h1F;
            WRITE_EN = 0;
            READ_EN = 0;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Read currently stored value", test_num);
            DATA_IN = 5'h00;
            WRITE_EN = 0;
            READ_EN = 1;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Write new value 5'h15", test_num);
            DATA_IN = 5'h15;
            WRITE_EN = 1;
            READ_EN = 0;

            #1;


            check_outputs(5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Hold new value 5'h15", test_num);
            DATA_IN = 5'h00;
            WRITE_EN = 0;
            READ_EN = 0;

            #1;


            check_outputs(5'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Simultaneous Read and Write 5'h1F", test_num);
            DATA_IN = 5'h1F;
            WRITE_EN = 1;
            READ_EN = 1;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Read back 5'h1F after simultaneous op", test_num);
            DATA_IN = 5'h00;
            WRITE_EN = 0;
            READ_EN = 1;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Change DATA_IN while WRITE_EN=0", test_num);
            WRITE_EN = 0;
            READ_EN = 0;
            DATA_IN = 5'h01; #2;
            DATA_IN = 5'h02; #2;
            DATA_IN = 5'h03; #2;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Write zero value", test_num);
            DATA_IN = 5'h00;
            WRITE_EN = 1;
            READ_EN = 0;

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Final Read verification", test_num);
            WRITE_EN = 0;
            READ_EN = 1;

            #1;


            check_outputs(5'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_control Testbench");
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
        input [4:0] expected_DATA_OUT;
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
