`timescale 1ns/1ps

module forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] sel;
    wire [31:0] forward_A;
    wire [31:0] forward_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    forwarding_unit dut (
        .A(A),
        .B(B),
        .sel(sel),
        .forward_A(forward_A),
        .forward_B(forward_B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: sel=00 (Forward A and B)", test_num);
        A = 32'hAAAA_BBBB;
        B = 32'hCCCC_DDDD;
        sel = 2'b00;
        #1;

        check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: sel=01 (Forward B only)", test_num);
        A = 32'h1111_2222;
        B = 32'h3333_4444;
        sel = 2'b01;
        #1;

        check_outputs(32'h0000_0000, 32'h3333_4444);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: sel=10 (Forward A only)", test_num);
        A = 32'h5555_6666;
        B = 32'h7777_8888;
        sel = 2'b10;
        #1;

        check_outputs(32'h5555_6666, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: sel=11 (Forward neither)", test_num);
        A = 32'h9999_0000;
        B = 32'h0000_1111;
        sel = 2'b11;
        #1;

        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Boundary Values", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        sel = 2'b00;
        #1;

        check_outputs(32'hFFFF_FFFF, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: sel=01 with B=All Fs", test_num);
        A = 32'hDEAD_BEEF;
        B = 32'hFFFF_FFFF;
        sel = 2'b01;
        #1;

        check_outputs(32'h0000_0000, 32'hFFFF_FFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("forwarding_unit Testbench");
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
        input [31:0] expected_forward_A;
        input [31:0] expected_forward_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_A === (expected_forward_A ^ forward_A ^ expected_forward_A) &&
                expected_forward_B === (expected_forward_B ^ forward_B ^ expected_forward_B)) begin
                $display("PASS");
                $display("  Outputs: forward_A=%h, forward_B=%h",
                         forward_A, forward_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_A=%h, forward_B=%h",
                         expected_forward_A, expected_forward_B);
                $display("  Got:      forward_A=%h, forward_B=%h",
                         forward_A, forward_B);
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
