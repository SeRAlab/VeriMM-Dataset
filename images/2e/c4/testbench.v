`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [1:0] control;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition", test_num);
            A = 64'd123456789;
            B = 64'd987654321;
            control = 2'b00;
            #1;

            check_outputs(64'd1111111110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Overflow (Wrap around)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            control = 2'b00;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Subtraction", test_num);
            A = 64'd1000;
            B = 64'd400;
            control = 2'b01;
            #1;

            check_outputs(64'd600);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction resulting in Zero", test_num);
            A = 64'hABCDEF0123456789;
            B = 64'hABCDEF0123456789;
            control = 2'b01;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Negative Result (2's Complement)", test_num);
            A = 64'd10;
            B = 64'd20;
            control = 2'b01;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND - General", test_num);
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'hAAAA_AAAA_AAAA_AAAA;
            control = 2'b10;
            #1;

            check_outputs(64'hA0A0A0A0A0A0A0A0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND - All Zeros", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000000;
            control = 2'b10;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND - Identity", test_num);
            A = 64'h123456789ABCDEF0;
            B = 64'h123456789ABCDEF0;
            control = 2'b10;
            #1;

            check_outputs(64'h123456789ABCDEF0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition of Large Randoms", test_num);
            A = 64'h1234_5678_1234_5678;
            B = 64'h8765_4321_8765_4321;
            control = 2'b00;
            #1;

            check_outputs(64'h9999_9999_9999_9999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction from Zero", test_num);
            A = 64'h0000000000000000;
            B = 64'h0000000000000001;
            control = 2'b01;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_64bit Testbench");
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
        input [63:0] expected_result;
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
