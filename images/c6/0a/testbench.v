`timescale 1ns/1ps

module accepts_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [3:0] In;
    wire Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    accepts dut (
        .Clock(Clock),
        .In(In),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin


            In = 4'b0;
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Aligned Pattern at Start", test_num);
            reset_dut();



            In = 4'b0010;
            @(posedge Clock);
            #1; In = 4'b0001;
            @(posedge Clock);
            #1; In = 4'b0001;
            @(posedge Clock);
            #1; In = 4'b1000;
            @(posedge Clock);
            #1; In = 4'b0000;

            repeat(25000 - 4) @(posedge Clock);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Misaligned Pattern", test_num);
            reset_dut();



            In = 4'b0001;
            @(posedge Clock);
            #1; In = 4'b0000;
            @(posedge Clock);
            #1; In = 4'b1000;
            @(posedge Clock);
            #1; In = 4'b1100;
            @(posedge Clock);
            #1; In = 4'b0000;

            repeat(25000 - 4) @(posedge Clock);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Pattern", test_num);
            reset_dut();

            for (i = 0; i < 25000; i = i + 1) begin
                In = 4'b1111;
                @(posedge Clock);
                #1;
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern at the End", test_num);
            reset_dut();


            repeat(25000 - 4) begin
                In = 4'b0000;
                @(posedge Clock);
                #1;
            end


            In = 4'b0010;
            @(posedge Clock);
            #1; In = 4'b0001;
            @(posedge Clock);
            #1; In = 4'b0001;
            @(posedge Clock);
            #1; In = 4'b1000;
            @(posedge Clock);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("accepts Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%b",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%b",
                         expected_Out);
                $display("  Got:      Out=%b",
                         Out);
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
        $dumpvars(0,Clock, In, Out);
    end

endmodule
