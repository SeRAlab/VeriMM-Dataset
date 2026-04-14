`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [2:0] select;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .data_in(data_in),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 0", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd0;

            #1;


            check_outputs(8'h88);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 1", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 2", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd2;

            #1;


            check_outputs(8'h66);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 3", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd3;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 4", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd4;

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 5", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd5;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 6", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd6;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Channel 7", test_num);
            data_in = 64'h1122334455667788;
            select = 3'd7;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros Input", test_num);
            data_in = 64'h0000000000000000;
            select = 3'd4;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones Input", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            select = 3'd2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits", test_num);
            data_in = 64'hAA55AA55AA55AA55;
            select = 3'd1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1 Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
