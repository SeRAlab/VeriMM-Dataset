`timescale 1ns/1ps

module data_bus_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_bus dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'h00000001;
            B = 32'hFFFFFFFF;
            $display("Test Case %0d: A LSB is 1 (A=1, B=all 1s)", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'h00000000;
            B = 32'h12345678;
            $display("Test Case %0d: A LSB is 0 (A=0, B=0x12345678)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            $display("Test Case %0d: A LSB is 1 (A=all 1s, B=0)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFE;
            B = 32'h55555555;
            $display("Test Case %0d: A LSB is 0 (A=all 1s except LSB, B=0x55555555)", test_num);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'hA5A5A5A5;
            B = 32'h5A5A5A5A;
            $display("Test Case %0d: A LSB is 1 (Mixed values)", test_num);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'hA5A5A5A4;
            B = 32'h5A5A5A5A;
            $display("Test Case %0d: A LSB is 0 (Mixed values)", test_num);
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_bus Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
