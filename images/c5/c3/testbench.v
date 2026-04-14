`timescale 1ns/1ps

module qqq_sub_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;
    wire [31:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qqq_sub dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .R(R)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'd100;
            B = 32'd40;
            Cin = 1'b0;
            $display("Test %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'd100;
            B = 32'd40;
            Cin = 1'b1;
            $display("Test %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'd59);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'hA5A5A5A5;
            B = 32'hA5A5A5A5;
            Cin = 1'b0;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'hA5A5A5A5;
            B = 32'hA5A5A5A5;
            Cin = 1'b1;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'd10;
            B = 32'd20;
            Cin = 1'b0;
            $display("Test %0d: A=%d, B=%d, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            Cin = 1'b0;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h00000000;
            B = 32'hFFFFFFFF;
            Cin = 1'b0;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h12345678;
            B = 32'h00000001;
            Cin = 1'b1;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'h12345676);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'h00000000;
            B = 32'h00000001;
            Cin = 1'b1;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'h80000000;
            B = 32'h7FFFFFFF;
            Cin = 1'b0;
            $display("Test %0d: A=%h, B=%h, Cin=%b", test_num, A, B, Cin);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qqq_sub Testbench");
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
        input [31:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
