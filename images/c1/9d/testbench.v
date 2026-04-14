`timescale 1ns/1ps

module rf_dist_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] a;
    reg clk;
    reg [31:0] d;
    reg [4:0] dpra;
    reg we;
    wire [31:0] dpo;
    wire [31:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rf_dist dut (
        .a(a),
        .clk(clk),
        .d(d),
        .dpra(dpra),
        .we(we),
        .dpo(dpo),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            d = 0;
            dpra = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual-Port Read", test_num);
            reset_dut();


            @(posedge clk);
            a = 5'd5;
            d = 32'hDEADBEEF;
            we = 1;
            @(posedge clk);
            we = 0;


            a = 5'd5;
            dpra = 5'd5;
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Independent Dual-Port Reading", test_num);
            reset_dut();


            @(posedge clk);
            a = 5'd10;
            d = 32'h12345678;
            we = 1;
            @(posedge clk);


            a = 5'd20;
            d = 32'h87654321;
            we = 1;
            @(posedge clk);
            we = 0;


            a = 5'd10;
            dpra = 5'd20;
            #2;

            #1;


            check_outputs(32'h87654321, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable", test_num);
            reset_dut();


            @(posedge clk);
            a = 5'd15;
            d = 32'hFFFFFFFF;
            we = 0;
            @(posedge clk);


            a = 5'd15;
            dpra = 5'd15;
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting a register", test_num);
            reset_dut();


            @(posedge clk);
            a = 5'd2;
            d = 32'hAAAA_AAAA;
            we = 1;
            @(posedge clk);


            a = 5'd2;
            d = 32'h5555_5555;
            we = 1;
            @(posedge clk);
            we = 0;

            a = 5'd2;
            dpra = 5'd2;
            #2;

            #1;


            check_outputs(32'h5555_5555, 32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Reg 31)", test_num);
            reset_dut();

            @(posedge clk);
            a = 5'd31;
            d = 32'h00C0_FFEE;
            we = 1;
            @(posedge clk);
            we = 0;

            a = 5'd31;
            dpra = 5'd0;
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00C0_FFEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rf_dist Testbench");
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
        input [31:0] expected_dpo;
        input [31:0] expected_spo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo) &&
                expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h, spo=%h",
                         dpo, spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h, spo=%h",
                         expected_dpo, expected_spo);
                $display("  Got:      dpo=%h, spo=%h",
                         dpo, spo);
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
        $dumpvars(0,a, clk, d, dpra, we, dpo, spo);
    end

endmodule
