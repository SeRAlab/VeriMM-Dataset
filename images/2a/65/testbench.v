`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in0;
    reg [4:0] in1;
    reg [4:0] in2;
    reg [4:0] in3;
    reg [4:0] in4;
    wire [4:0] out0;
    wire [4:0] out1;
    wire [4:0] out2;
    wire [4:0] out3;
    wire [4:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 5'b00000; in1 = 5'b00000; in2 = 5'b00000; in3 = 5'b00000; in4 = 5'b00000;
            $display("Test %0d: All Zeros (Empty Image)", test_num);
            #1;

            check_outputs(5'b00000, 5'b00000, 5'b00000, 5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            in0 = 5'b00000; in1 = 5'b00000; in2 = 5'b00100; in3 = 5'b00000; in4 = 5'b00000;
            $display("Test %0d: Single Center Pixel", test_num);

            #1;


            check_outputs(5'b00000, 5'b01110, 5'b01110, 5'b01110, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            in0 = 5'b00001; in1 = 5'b00000; in2 = 5'b00000; in3 = 5'b00000; in4 = 5'b10000;
            $display("Test %0d: Corner Pixels", test_num);


            #1;



            check_outputs(5'b00011, 5'b00011, 5'b00000, 5'b11000, 5'b11000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            in0 = 5'b11111; in1 = 5'b11111; in2 = 5'b11111; in3 = 5'b11111; in4 = 5'b11111;
            $display("Test %0d: Full Image (All Ones)", test_num);
            #1;

            check_outputs(5'b11111, 5'b11111, 5'b11111, 5'b11111, 5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            in0 = 5'b00000; in1 = 5'b00000; in2 = 5'b11111; in3 = 5'b00000; in4 = 5'b00000;
            $display("Test %0d: Horizontal Middle Line", test_num);

            #1;


            check_outputs(5'b00000, 5'b11111, 5'b11111, 5'b11111, 5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            in0 = 5'b00100; in1 = 5'b00100; in2 = 5'b00100; in3 = 5'b00100; in4 = 5'b00100;
            $display("Test %0d: Vertical Middle Line", test_num);

            #1;


            check_outputs(5'b01110, 5'b01110, 5'b01110, 5'b01110, 5'b01110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            in0 = 5'b00000; in1 = 5'b01010; in2 = 5'b00000; in3 = 5'b01010; in4 = 5'b00000;
            $display("Test %0d: Sparse Pattern", test_num);


            #1;



            check_outputs(5'b11111, 5'b11111, 5'b11111, 5'b11111, 5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            in0 = 5'b00000; in1 = 5'b00010; in2 = 5'b00000; in3 = 5'b00000; in4 = 5'b00000;
            $display("Test %0d: Edge-adjacent Pixel", test_num);

            #1;


            check_outputs(5'b00111, 5'b00111, 5'b00111, 5'b00000, 5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_dilation Testbench");
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
        input [4:0] expected_out0;
        input [4:0] expected_out1;
        input [4:0] expected_out2;
        input [4:0] expected_out3;
        input [4:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h",
                         out0, out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h, out4=%h",
                         out0, out1, out2, out3, out4);
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
