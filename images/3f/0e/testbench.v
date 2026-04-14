`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg BL;
    reg [15:0] D;
    reg WE;
    reg WL;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .BL(BL),
        .D(D),
        .WE(WE),
        .WL(WL),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WL = 0;
        forever #5 WL = ~WL;
    end

        task reset_dut;

        begin
            WE = 0;
            D = 0;
            BL = 1;

            @(posedge WL);
            @(negedge WL);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write and Read 0xAAAA", test_num);
            reset_dut();


            @(negedge WL);
            D = 16'hAAAA;
            WE = 1;
            @(posedge WL);
            @(negedge WL);
            WE = 0;


            @(posedge WL);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write and Read 0x5555", test_num);
            reset_dut();


            @(negedge WL);
            D = 16'h5555;
            WE = 1;
            @(posedge WL);
            @(negedge WL);
            WE = 0;


            @(posedge WL);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data Persistence Check", test_num);
            reset_dut();


            @(negedge WL);
            D = 16'h1234;
            WE = 1;
            @(posedge WL);
            @(negedge WL);


            WE = 0;
            D = 16'hFFFF;
            @(posedge WL);
            @(negedge WL);


            @(posedge WL);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write and Read All Zeros", test_num);
            reset_dut();

            @(negedge WL);
            D = 16'h0000;
            WE = 1;
            @(posedge WL);
            @(negedge WL);
            WE = 0;

            @(posedge WL);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write and Read All Ones", test_num);
            reset_dut();

            @(negedge WL);
            D = 16'hFFFF;
            WE = 1;
            @(posedge WL);
            @(negedge WL);
            WE = 0;

            @(posedge WL);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BL Low De-selection Check", test_num);
            reset_dut();


            @(negedge WL);
            BL = 1;
            D = 16'h8888;
            WE = 1;
            @(posedge WL);
            @(negedge WL);
            WE = 0;





            @(posedge WL);
            #2;
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
        $display("sram_cell Testbench");
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
        $dumpvars(0,BL, D, WE, WL, Q);
    end

endmodule
