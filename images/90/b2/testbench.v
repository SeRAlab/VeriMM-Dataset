`timescale 1ns/1ps

module elevator_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg down_button;
    reg up_button;
    wire [1:0] floor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator_controller dut (
        .areset(areset),
        .clk(clk),
        .down_button(down_button),
        .up_button(up_button),
        .floor(floor)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            up_button = 0;
            down_button = 0;
            #12;
            areset = 0;
            #8;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Power-on Reset check");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Ground to First floor");
            reset_dut();
            up_button = 1;
            @(posedge clk);
            #2;
            up_button = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full Ascent (Ground to Third)");
            reset_dut();
            up_button = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            up_button = 0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Third floor to Second floor");
            reset_dut();

            up_button = 1;
            repeat(3) @(posedge clk);
            up_button = 0;

            down_button = 1;
            @(posedge clk);
            #2;
            down_button = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full Descent (Third to Ground)");
            reset_dut();

            up_button = 1;
            repeat(3) @(posedge clk);
            up_button = 0;

            down_button = 1;
            repeat(3) @(posedge clk);
            #2;
            down_button = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Idle at First floor");
            reset_dut();
            up_button = 1;
            @(posedge clk);
            up_button = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Idle at Third floor");
            reset_dut();
            up_button = 1;
            repeat(3) @(posedge clk);
            up_button = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Ground -> First -> Ground");
            reset_dut();
            up_button = 1;
            @(posedge clk);
            up_button = 0;
            down_button = 1;
            @(posedge clk);
            #2;
            down_button = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Boundary Check (Up at Third Floor)");
            reset_dut();
            up_button = 1;
            repeat(5) @(posedge clk);
            #2;
            up_button = 0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary Check (Down at Ground Floor)");
            reset_dut();
            down_button = 1;
            repeat(2) @(posedge clk);
            #2;
            down_button = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("elevator_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_floor;
        begin
            if (expected_floor === (expected_floor ^ floor ^ expected_floor)) begin
                $display("PASS");
                $display("  Outputs: floor=%h",
                         floor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: floor=%h",
                         expected_floor);
                $display("  Got:      floor=%h",
                         floor);
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
        $dumpvars(0,areset, clk, down_button, up_button, floor);
    end

endmodule
