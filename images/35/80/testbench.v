`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [7:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .data(data),
        .encoded(encoded)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (Identity)", test_num);
            data = 4'b0000;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit (Bit 0)", test_num);
            data = 4'b0001;

            #1;


            check_outputs(8'h1B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit (Bit 1)", test_num);
            data = 4'b0010;
            #1;

            check_outputs(8'h27);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit (Bit 2)", test_num);
            data = 4'b0100;
            #1;

            check_outputs(8'h4E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit (Bit 3)", test_num);
            data = 4'b1000;
            #1;

            check_outputs(8'h8D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            data = 4'b1111;


            #1;



            check_outputs(8'hF1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (1010)", test_num);
            data = 4'b1010;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0101)", test_num);
            data = 4'b0101;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle Bits", test_num);
            data = 4'b0110;

            #1;


            check_outputs(8'h69);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Bits", test_num);
            data = 4'b1001;

            #1;


            check_outputs(8'h96);
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
        input [7:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h",
                         encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h",
                         expected_encoded);
                $display("  Got:      encoded=%h",
                         encoded);
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
