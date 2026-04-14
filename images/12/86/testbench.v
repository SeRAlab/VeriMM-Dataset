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
        test_num = 1;
        $display("Test %0d: Multiply by zero (A=0, B=0)", test_num);
        A = 64'h0;
        B = 64'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Multiply by zero (A=Max, B=0)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Identity multiplication (A=1, B=1)", test_num);
        A = 64'h1;
        B = 64'h1;
        #1;

        check_outputs(128'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Identity multiplication (A=Max, B=1)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h1;
        #1;

        check_outputs({64'h0, 64'hFFFFFFFFFFFFFFFF});
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Power of 2 multiplication (2^32 * 2^32 = 2^64)", test_num);
        A = 64'h0000000100000000;
        B = 64'h0000000100000000;
        #1;

        check_outputs(128'h00000000000000010000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Large value multiplication (Maximum unsigned values)", test_num);

        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Small integer multiplication", test_num);
        A = 64'd123456789;
        B = 64'd987654321;

        #1;


        check_outputs(128'd121932631112635269);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Alternating bit patterns", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;

        #1;


        check_outputs(128'h38E38E38E38E38E38E38E38E38E38E38);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Significant high-bit multiplication", test_num);
        A = 64'h8000000000000000;
        B = 64'h0000000000000002;
        #1;

        check_outputs(128'h00000000000000010000000000000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Hex pattern check", test_num);
        A = 64'h1234567812345678;
        B = 64'h0000000000000010;
        #1;

        check_outputs(128'h00000000000000012345678123456780);
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
