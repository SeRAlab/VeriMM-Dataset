`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [6:0] data_out1;
    wire [6:0] data_out2;
    wire [6:0] data_out3;
    wire [6:0] data_out4;
    wire [6:0] data_out5;
    wire [6:0] data_out6;
    wire [6:0] data_out7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .data_in(data_in),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3),
        .data_out4(data_out4),
        .data_out5(data_out5),
        .data_out6(data_out6),
        .data_out7(data_out7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            data_in = 16'h0000;


            #1;



            check_outputs(7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB Input (16'h0001)", test_num);
            data_in = 16'h0001;




            #1;





            check_outputs(7'h00, 7'h00, 7'h00, 7'h01, 7'h1B, 7'h23, 7'h4A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Input (16'h8000)", test_num);
            data_in = 16'h8000;

            #1;


            check_outputs(7'h08, 7'h00, 7'h00, 7'h00, 7'h5C, 7'h11, 7'h3E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (16'hFFFF)", test_num);
            data_in = 16'hFFFF;

            #1;


            check_outputs(7'h0F, 7'h0F, 7'h0F, 7'h0F, 7'h62, 7'h71, 7'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern A (16'hAAAA)", test_num);
            data_in = 16'hAAAA;
            #1;

            check_outputs(7'h0A, 7'h0A, 7'h0A, 7'h0A, 7'h2D, 7'h3F, 7'h09);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern 5 (16'h5555)", test_num);
            data_in = 16'h5555;
            #1;

            check_outputs(7'h05, 7'h05, 7'h05, 7'h05, 7'h4F, 7'h4E, 7'h1C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Symbols (16'h1234)", test_num);
            data_in = 16'h1234;

            #1;


            check_outputs(7'h01, 7'h02, 7'h03, 7'h04, 7'h7A, 7'h12, 7'h6B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [6:0] expected_data_out1;
        input [6:0] expected_data_out2;
        input [6:0] expected_data_out3;
        input [6:0] expected_data_out4;
        input [6:0] expected_data_out5;
        input [6:0] expected_data_out6;
        input [6:0] expected_data_out7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_data_out3 === (expected_data_out3 ^ data_out3 ^ expected_data_out3) &&
                expected_data_out4 === (expected_data_out4 ^ data_out4 ^ expected_data_out4) &&
                expected_data_out5 === (expected_data_out5 ^ data_out5 ^ expected_data_out5) &&
                expected_data_out6 === (expected_data_out6 ^ data_out6 ^ expected_data_out6) &&
                expected_data_out7 === (expected_data_out7 ^ data_out7 ^ expected_data_out7)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h, data_out5=%h, data_out6=%h, data_out7=%h",
                         data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h, data_out5=%h, data_out6=%h, data_out7=%h",
                         expected_data_out1, expected_data_out2, expected_data_out3, expected_data_out4, expected_data_out5, expected_data_out6, expected_data_out7);
                $display("  Got:      data_out1=%h, data_out2=%h, data_out3=%h, data_out4=%h, data_out5=%h, data_out6=%h, data_out7=%h",
                         data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7);
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
