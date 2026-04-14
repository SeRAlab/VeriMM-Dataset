`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .A(A),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WE = 0;
        forever #5 WE = ~WE;
    end

        task reset_dut;

        begin
            A = 4'h0;
            D = 16'h0000;


            @(negedge WE);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0xABCD to address 0", test_num);
            reset_dut();

            A = 4'h0;
            D = 16'hABCD;

            @(posedge WE);

            @(negedge WE);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0x55AA to address 15", test_num);
            reset_dut();

            A = 4'hF;
            D = 16'h55AA;
            @(posedge WE);
            @(negedge WE);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying address isolation (Addr 3 vs Addr 4)", test_num);
            reset_dut();


            A = 4'h3; D = 16'h1111;
            @(posedge WE); @(negedge WE);


            A = 4'h4; D = 16'h2222;
            @(posedge WE); @(negedge WE);


            A = 4'h3;
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting data at address 7", test_num);
            reset_dut();


            A = 4'h7; D = 16'hAAAA;
            @(posedge WE); @(negedge WE);


            A = 4'h7; D = 16'h5555;
            @(posedge WE); @(negedge WE);

            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 0xFFFF to address 10", test_num);
            reset_dut();

            A = 4'hA;
            D = 16'hFFFF;
            @(posedge WE);
            @(negedge WE);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        $dumpvars(0,A, D, WE, Q);
    end

endmodule
