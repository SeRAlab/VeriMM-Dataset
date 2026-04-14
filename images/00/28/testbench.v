`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg CE;
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
        .CE(CE),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CE = 0;
        forever #5 CE = ~CE;
    end

        task reset_dut;

        begin
            A = 4'h0;
            D = 16'h0000;
            WE = 0;
            @(posedge CE);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read Address 0", test_num);
            reset_dut();


            A = 4'h0; D = 16'hABCD; WE = 1;
            @(posedge CE); #1;


            WE = 0;
            @(posedge CE); #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Address 15 Write/Read", test_num);
            reset_dut();


            A = 4'hF; D = 16'h55AA; WE = 1;
            @(posedge CE); #1;


            WE = 0;
            @(posedge CE); #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Data at Address 5", test_num);
            reset_dut();


            A = 4'h5; D = 16'h1111; WE = 1;
            @(posedge CE); #1;


            D = 16'hFFFF;
            @(posedge CE); #1;


            WE = 0;
            @(posedge CE); #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Write to A doesn't affect B", test_num);
            reset_dut();


            A = 4'h2; D = 16'h2222; WE = 1;
            @(posedge CE); #1;


            A = 4'h3; D = 16'h3333; WE = 1;
            @(posedge CE); #1;


            A = 4'h2; WE = 0;
            @(posedge CE); #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify WE=0 prevents writing", test_num);
            reset_dut();


            A = 4'h8; D = 16'h8888; WE = 1;
            @(posedge CE); #1;


            D = 16'h9999; WE = 0;
            @(posedge CE); #1;


            @(posedge CE); #1;
            #1;

            check_outputs(16'h8888);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, CE, D, WE, Q);
    end

endmodule
