`timescale 1ns/1ps

module bitwise_xor_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg TE;
    wire [31:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_xor dut (
        .A(A),
        .B(B),
        .TE(TE),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            TE = 1'b0;
            A = 32'hA5A5A5A5;
            B = 32'h5A5A5A5A;
            $display("Test %0d: TE=0, A=%h, B=%h. Expecting Z=0.", test_num, A, B);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            TE = 1'b1;
            A = 32'h00000000;
            B = 32'h00000000;
            $display("Test %0d: TE=1, A=0, B=0. Expecting Z=0.", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            TE = 1'b1;
            A = 32'hFEDCBA98;
            B = 32'h00000000;
            $display("Test %0d: TE=1, XOR with 0. Expecting Z=%h.", test_num, A);
            #1;

            check_outputs(A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            TE = 1'b1;
            A = 32'h12345678;
            B = 32'h12345678;
            $display("Test %0d: TE=1, XOR identical inputs. Expecting Z=0.", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            TE = 1'b1;
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            $display("Test %0d: TE=1, XOR alternating bits. Expecting Z=FFFFFFFF.", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            TE = 1'b1;
            A = 32'hDEADBEEF;
            B = 32'hCAFEBABE;

            $display("Test %0d: TE=1, Random patterns DEADBEEF ^ CAFEBABE.", test_num);
            #1;

            check_outputs(32'h14530451);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            TE = 1'b0;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            $display("Test %0d: TE=0, ensuring output is disabled even with all ones.", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_xor Testbench");
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
        input [31:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
