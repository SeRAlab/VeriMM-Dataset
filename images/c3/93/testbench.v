`timescale 1ns/1ps

module ADD32_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg C;
    reg CE;
    reg R;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADD32 dut (
        .A(A),
        .B(B),
        .C(C),
        .CE(CE),
        .R(R),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        A <= 0;
        B <= 0;
        CE <= 0;
        R <= 1;
        @(posedge C);
        #1;
        R <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Positive Addition", test_num);
        reset_dut();
        A <= 32'd1000;
        B <= 32'd2000;
        CE <= 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(32'd3000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Negative Number Addition", test_num);
        reset_dut();
        A <= -32'd500;
        B <= -32'd250;
        CE <= 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(-32'd750);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Reset Priority", test_num);
        reset_dut();
        R <= 1;
        A <= 32'hFFFFFFFF;
        B <= 32'h1;
        CE <= 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Clock Enable (Disabled)", test_num);
        reset_dut();
        A <= 32'h1234;
        B <= 32'h5678;
        CE <= 0;
        @(posedge C);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Max Positive Wrap-around", test_num);
        reset_dut();
        A <= 32'h7FFFFFFF;
        B <= 32'h1;
        CE <= 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Large Signed Addition", test_num);
        reset_dut();
        A <= 32'sd1000000;
        B <= -32'sd2000000;
        CE <= 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(-32'sd1000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Sequential CE Toggle", test_num);
        reset_dut();

        A <= 32'd10;
        B <= 32'd20;
        CE <= 1;
        @(posedge C);
        #1;


        A <= 32'd50;
        B <= 32'd50;
        CE <= 0;
        @(posedge C);
        #1;
        #1;

        check_outputs(32'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADD32 Testbench");
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
        input [31:0] expected_S;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, C, CE, R, S);
    end

endmodule
