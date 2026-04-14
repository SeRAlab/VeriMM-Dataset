`timescale 1ns/1ps

module multiplier_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [127:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(128'h0);

            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by One", test_num);
            A = 64'h1;
            B = 64'h5555555555555555;
            #1;

            check_outputs(128'h00000000000000005555555555555555);

            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h1;
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Integers", test_num);
            A = 64'd12345678;
            B = 64'd87654321;

            #1;


            check_outputs(128'd1082151605330638);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of 2", test_num);
            A = 64'h0000000100000000;
            B = 64'h0000000100000000;

            #1;


            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Values (Crossing 64-bit boundary)", test_num);
            A = 64'hFFFFFFFF00000000;
            B = 64'h00000000FFFFFFFF;

            #1;


            check_outputs(128'h00000000FFFFFFFE0000000100000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (2^64-1 * 2^64-1)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;


            #1;



            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Large Patterns", test_num);
            A = 64'hAAAAAAAA_AAAAAAAA;
            B = 64'h55555555_55555555;

            #1;


            check_outputs(128'h38E38E38E38E38E31C71C71C71C71C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime-like Large Multiplication", test_num);
            A = 64'hDEADC0DE_BAADF00D;
            B = 64'h12345678_9ABCDEF0;

            #1;


            check_outputs(128'hFD289F5661D756570A942F5CE0AD30D2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64bit Testbench");
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
        input [127:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
