`timescale 1ns/1ps

module sata_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] command;
    wire [2:0] category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_decoder dut (
        .command(command),
        .category(category)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NOP (command = 00000)", test_num);
            command = 5'b00000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Command Min (command = 00001)", test_num);
            command = 5'b00001;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Command Max (command = 00010)", test_num);
            command = 5'b00010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write Command Min (command = 00011)", test_num);
            command = 5'b00011;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write Command Max (command = 00100)", test_num);
            command = 5'b00100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identify Device (command = 00101)", test_num);
            command = 5'b00101;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reserved Command Min (command = 00110)", test_num);
            command = 5'b00110;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reserved Command Mid (command = 01010)", test_num);
            command = 5'b01010;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reserved Command Max (command = 11111)", test_num);
            command = 5'b11111;
            #1;

            check_outputs(3'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_decoder Testbench");
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
        input [2:0] expected_category;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_category === (expected_category ^ category ^ expected_category)) begin
                $display("PASS");
                $display("  Outputs: category=%h",
                         category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: category=%h",
                         expected_category);
                $display("  Got:      category=%h",
                         category);
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
