`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    wire A_leads_B;
    wire B_leads_A;
    wire aligned;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .A(A),
        .B(B),
        .clk(clk),
        .A_leads_B(A_leads_B),
        .B_leads_A(B_leads_A),
        .aligned(aligned)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A leads B", test_num);
        reset_dut();

        @(posedge clk);
        A = 1;
        repeat(2) @(posedge clk);
        B = 1;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: B leads A", test_num);
        reset_dut();

        @(posedge clk);
        B = 1;
        repeat(2) @(posedge clk);
        A = 1;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signals Aligned (Simultaneous high)", test_num);
        reset_dut();

        @(posedge clk);
        A = 1;
        B = 1;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signals Aligned (Both low)", test_num);
        reset_dut();


        repeat(3) @(posedge clk);

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: A leads B by 1 cycle", test_num);
        reset_dut();

        @(posedge clk);
        A = 1;
        @(posedge clk);
        B = 1;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_A_leads_B;
        input expected_B_leads_A;
        input expected_aligned;
        begin
            if (expected_A_leads_B === (expected_A_leads_B ^ A_leads_B ^ expected_A_leads_B) &&
                expected_B_leads_A === (expected_B_leads_A ^ B_leads_A ^ expected_B_leads_A) &&
                expected_aligned === (expected_aligned ^ aligned ^ expected_aligned)) begin
                $display("PASS");
                $display("  Outputs: A_leads_B=%b, B_leads_A=%b, aligned=%b",
                         A_leads_B, B_leads_A, aligned);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_leads_B=%b, B_leads_A=%b, aligned=%b",
                         expected_A_leads_B, expected_B_leads_A, expected_aligned);
                $display("  Got:      A_leads_B=%b, B_leads_A=%b, aligned=%b",
                         A_leads_B, B_leads_A, aligned);
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
        $dumpvars(0,A, B, clk, A_leads_B, B_leads_A, aligned);
    end

endmodule
