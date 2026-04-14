`timescale 1ns/1ps

module shift_register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg ld_en;
    reg rst;
    reg sh_en;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_32bit dut (
        .clk(clk),
        .din(din),
        .ld_en(ld_en),
        .rst(rst),
        .sh_en(sh_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sh_en = 0;
            ld_en = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel load (0xACE1_B0BA)", test_num);
            reset_dut();
            @(negedge clk);
            din = 32'hACE1_B0BA;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;
            #1;

            check_outputs(32'hACE1_B0BA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit shift left", test_num);
            reset_dut();

            @(negedge clk);
            din = 32'h0000_0001;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;
            sh_en = 1;
            @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 4 bits left", test_num);
            reset_dut();

            @(negedge clk);
            din = 32'h0000_000F;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;
            sh_en = 1;
            repeat(4) @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(32'h0000_00F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (Load vs Shift)", test_num);
            reset_dut();

            @(negedge clk);
            din = 32'hAAAA_AAAA;
            ld_en = 1;
            @(posedge clk);

            #1 din = 32'hFFFF_FFFF;
            ld_en = 1;
            sh_en = 1;
            @(posedge clk);
            #1 ld_en = 0; sh_en = 0;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift out MSB", test_num);
            reset_dut();
            @(negedge clk);
            din = 32'h8000_0000;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;
            sh_en = 1;
            @(posedge clk);
            #1 sh_en = 0;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify idle state (enables off)", test_num);
            reset_dut();
            @(negedge clk);
            din = 32'h5555_AAAA;
            ld_en = 1;
            @(posedge clk);
            #1 ld_en = 0;
            sh_en = 0;
            repeat(5) @(posedge clk);
            #1
            #1;

            check_outputs(32'h5555_AAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_32bit Testbench");
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, ld_en, rst, sh_en, dout);
    end

endmodule
