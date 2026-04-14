`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .A(A),
        .D(D),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Write/Read at Addr 0", test_num);
            WE = 1;
            A = 4'h0;
            D = 16'hABCD;
            #10;
            WE = 0;
            #10;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Write/Read at Boundary Addr 15", test_num);
            WE = 1;
            A = 4'hF;
            D = 16'hFFFF;
            #10;
            WE = 0;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Overwrite Data at Addr 7", test_num);

            WE = 1; A = 4'h7; D = 16'h1111;
            #10;

            WE = 1; A = 4'h7; D = 16'h2222;
            #10;
            WE = 0;
            #10;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Multi-address Write Persistence", test_num);
            WE = 1; A = 4'h1; D = 16'hAAAA; #10;
            WE = 1; A = 4'h2; D = 16'hBBBB; #10;
            WE = 1; A = 4'h3; D = 16'hCCCC; #10;
            WE = 0; A = 4'h2;
            #10;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating bit pattern test", test_num);
            WE = 1;
            A = 4'hA;
            D = 16'h5555;
            #10;
            WE = 0;
            #10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Write Disable (WE=0) Verification", test_num);

            WE = 1; A = 4'h4; D = 16'h1234; #10;

            WE = 0; A = 4'h4; D = 16'h9999; #10;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_16bit Testbench");
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
        input [15:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
