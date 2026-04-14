`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg LOAD;
    reg [2:0] LOAD_VAL;
    reg RST;
    wire [2:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .CLK(CLK),
        .EN(EN),
        .LOAD(LOAD),
        .LOAD_VAL(LOAD_VAL),
        .RST(RST),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            LOAD = 0;
            LOAD_VAL = 3'b000;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset verification", test_num);
            reset_dut();
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic increment (0 to 4)", test_num);
            reset_dut();
            EN = 1;
            repeat(4) @(posedge CLK);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load value 3'b110", test_num);
            reset_dut();
            LOAD = 1;
            LOAD_VAL = 3'b110;
            @(posedge CLK);
            #1 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: EN=0 maintains state", test_num);
            reset_dut();

            LOAD = 1; LOAD_VAL = 3'b010; @(posedge CLK);

            LOAD = 0; EN = 0;
            repeat(3) @(posedge CLK);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Load priority over increment", test_num);
            reset_dut();
            LOAD = 1;
            EN = 1;
            LOAD_VAL = 3'b111;
            @(posedge CLK);
            #1 #1;
 check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Rollover check (7 to 0)", test_num);
            reset_dut();

            LOAD = 1; LOAD_VAL = 3'b111; @(posedge CLK);

            LOAD = 0; EN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Load 2 then increment twice", test_num);
            reset_dut();

            LOAD = 1; LOAD_VAL = 3'b010; @(posedge CLK);

            LOAD = 0; EN = 1;
            repeat(2) @(posedge CLK);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Reset override during operation", test_num);
            reset_dut();
            EN = 1;
            repeat(3) @(posedge CLK);
            RST = 1;
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, EN, LOAD, LOAD_VAL, RST, COUNT);
    end

endmodule
