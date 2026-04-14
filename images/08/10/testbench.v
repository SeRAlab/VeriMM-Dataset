`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DI;
    reg WE;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .CLK(CLK),
        .DI(DI),
        .WE(WE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE <= 0;
            DI <= 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xA5)", test_num);
            reset_dut();

            WE <= 1;
            DI <= 8'hA5;
            @(posedge CLK);
            #1;

            WE <= 0;
            DI <= 8'h00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence with WE=0", test_num);
            reset_dut();


            WE <= 1;
            DI <= 8'h55;
            @(posedge CLK);
            #1;


            WE <= 0;
            DI <= 8'hFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive writes (0x11 -> 0x22 -> 0x33)", test_num);
            reset_dut();

            WE <= 1;
            DI <= 8'h11;
            @(posedge CLK);
            #1;

            DI <= 8'h22;
            @(posedge CLK);
            #1;

            DI <= 8'h33;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values (0xFF then 0x00)", test_num);
            reset_dut();

            WE <= 1;
            DI <= 8'hFF;
            @(posedge CLK);
            #1;

            DI <= 8'h00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DI change between clock edges", test_num);
            reset_dut();

            WE <= 1;
            DI <= 8'hAA;
            @(posedge CLK);
            #1;


            DI <= 8'hBB;
            #2;


            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,CLK, DI, WE, DO);
    end

endmodule
